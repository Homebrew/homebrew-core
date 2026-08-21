class Convox < Formula
  desc "Command-line interface for the Convox PaaS"
  homepage "https://convox.com/"
  url "https://github.com/convox/convox/archive/refs/tags/3.25.4.tar.gz"
  sha256 "f0b53fea813cd6c8af8461dde0ebb08858cdcf5d2b5d57ca7dc78eaf89814f8a"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/convox/convox.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cd159bb976a247b84f4fc83a6292ad43e5b24dcd4c3e69beae261dc7371249d2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9b2dbd7708dc977192d98dc9ca7b634b14decfbfc42ae0da99476f7eb10e063e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2f7114387835902a1b4ea8d013a530dbe14db226cdecc527c27bbe039aae8733"
    sha256 cellar: :any_skip_relocation, sonoma:        "fe4e16e129bda0f4c7d0ea1dcd6cdeaed95731839ca8cf17fb59a38266ac43b6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b21fe345cf1dcfce46077d1e034be95243980b4dd17ecdf32d264677001cc4b5"
    sha256 cellar: :any,                 x86_64_linux:  "e73f1c98ad64e570ec10ca0eee802d42e707ccea495ccdd4a182f7b19248f142"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build

  on_linux do
    depends_on "systemd" # for libudev
  end

  def install
    ldflags = "-X main.version=#{version}"
    system "go", "build", "-mod=readonly", *std_go_args(ldflags:), "./cmd/convox"
  end

  test do
    assert_equal "Authenticating with localhost... ERROR: invalid login\n",
      shell_output("#{bin}/convox login -t invalid localhost 2>&1", 1)
  end
end
