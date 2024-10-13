class DockerCredentialHelper < Formula
  desc "Platform keystore credential helper for Docker"
  homepage "https://github.com/docker/docker-credential-helpers"
  url "https://github.com/docker/docker-credential-helpers/archive/refs/tags/v0.8.2.tar.gz"
  sha256 "bc887a126dc294f5c60d0b2d50481cc9ee330249c482bcedd16607e4d18c98ba"
  license "MIT"
  head "https://github.com/docker/docker-credential-helpers.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "10090a385f96a72b82a69d8b2119e92c98f1dd5f521c06aae78eba36998cb543"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2752b85c6b23f36246c8d0acbd27c21867e02992052065e6246e612489da4282"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "040055d7b2b5a6c28a5b9cbbd02db57851cfd802b3847d1309296e8528c44e1c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1854fc6611526742b847c83413ed00dc40880840055ff48a6503d9b2df4c9c53"
    sha256 cellar: :any_skip_relocation, sonoma:         "c16d39b6d79d9603ea4deec7af1875801e026e4af5a53ce4da80d038921eca1d"
    sha256 cellar: :any_skip_relocation, ventura:        "ae3bf8797540c1e053ab6fbd1bedcaf03417e9ba938cbfe37107ce63afd1fdf7"
    sha256 cellar: :any_skip_relocation, monterey:       "e4eebc9ee7fb41bf05e20710561f238993f0586e10833852bc2818c08e73be9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "091c57eb5a7ea0f35d599cf0395f28ed611a0da4979ce2db28c57680433de570"
  end

  depends_on "go" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "libsecret"
  end

  def install
    if OS.mac?
      system "make", "osxkeychain"
      bin.install "bin/build/docker-credential-osxkeychain"
    else
      system "make", "pass"
      system "make", "secretservice"
      bin.install "bin/build/docker-credential-pass"
      bin.install "bin/build/docker-credential-secretservice"
    end
  end

  test do
    if OS.mac?
      run_output = shell_output("#{bin}/docker-credential-osxkeychain", 1)
      assert_match "Usage: docker-credential-osxkeychain", run_output
    else
      run_output = shell_output("#{bin}/docker-credential-pass list")
      assert_match "{}", run_output

      run_output = shell_output("#{bin}/docker-credential-secretservice list", 1)
      assert_match "Cannot autolaunch D-Bus without X11", run_output
    end
  end
end
