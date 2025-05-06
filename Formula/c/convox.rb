class Convox < Formula
  desc "Command-line interface for the Convox PaaS"
  homepage "https://convox.com/"
  url "https://github.com/convox/convox/archive/refs/tags/3.21.2.tar.gz"
  sha256 "c14371deec5615f8a03a262836f530f689afa04b8eb6cf6d4a781cb537f81fe0"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/convox/convox.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7e7e9fb8c6e4f00e26a64a26c03a913e84185199629b5b442eca79bd73a9d795"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "039c65cb3dbf1ba8426666b18d3b7e0fbc8d8de8517e2c99f9e3a38e79291b9e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "10ca5308a3107f0ab2773567d58b4bb3cf354d6941ced5e47dd78e7e90e13e00"
    sha256 cellar: :any_skip_relocation, sonoma:        "500f6d150e2575d72f3e10757ddee4de663ccdf5c03a2de7d7e409b0945d8172"
    sha256 cellar: :any_skip_relocation, ventura:       "6b8dbfa97f10d666f0c9fe194817e1e354b38c0c8f5a747702622d6c13db416d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "223ab57bf41bf1da8c42694dc8c2d687a1f111f2235a61f6844760df4cf13648"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "988070c8608a854e20c4eb9104baa837ed90d20570951c52e5d811223802a3e9"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build

  on_linux do
    depends_on "systemd" # for libudev
  end

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", "-mod=readonly", *std_go_args(ldflags:), "./cmd/convox"
  end

  test do
    assert_equal "Authenticating with localhost... ERROR: invalid login\n",
      shell_output("#{bin}/convox login -t invalid localhost 2>&1", 1)
  end
end
