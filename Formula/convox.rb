class Convox < Formula
  desc "Command-line interface for the Convox PaaS"
  homepage "https://convox.com/"
  url "https://github.com/convox/convox/archive/3.0.38.tar.gz"
  sha256 "5ab341efe1b0277e8c911132d69275f0c16cbd8f0662c3f78c596ec9d7a5d73c"
  license "Apache-2.0"
  version_scheme 1

  bottle do
    cellar :any_skip_relocation
    sha256 "34e4b16f3073470d2355a512c8e32290b7aa3d008ed8a3812fbf596eb2ffd840" => :catalina
    sha256 "86ee7d68ca0957a877923501931e0edf23fb8b3c7a7947e147be6bbfc6a9f78c" => :mojave
    sha256 "e47cff8d65624dfd19ae8dfee72166bc6096d62dbd97985b7fcb6dae2841a4b5" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X main.version=#{version}
    ].join(" ")

    system "go", "build", *std_go_args, "-mod=vendor", "-ldflags", ldflags, "./cmd/convox"
  end

  test do
    assert_equal "Authenticating with localhost... ERROR: invalid login\n",
      shell_output("#{bin}/convox login -t invalid localhost 2>&1", 1)
  end
end
