class Dive < Formula
  desc "Tool for exploring each layer in a docker image"
  homepage "https://github.com/wagoodman/dive"
  url "https://github.com/wagoodman/dive.git",
      tag:      "v0.12.0",
      revision: "925cdd86482edec42185794620a1e616b79bbee5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "bf611f1db98b6448498c325f832af72d2073dcf4341ed7d13b1e6c9a992d3704"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3d2f18e2bd91ef512aaa1dd5b973131c4ba4cf6925cbc9164bcad22f60b1aad1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9596d77ba519803a3180c20c0c331d2d6378531d8444b54a0b5453db94ecadde"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "27d97e07f727d8a28efb7cda0d9240828971f8f7b037d5eaeff6df48742dd106"
    sha256 cellar: :any_skip_relocation, sonoma:         "4696a476e34df99d220d6a9c219edaed6b4f97debf887555a50e522761058283"
    sha256 cellar: :any_skip_relocation, ventura:        "7e617151108b1c92f81af06cc3887ab583aa5b7edf5f80b6cf07745ad524b9df"
    sha256 cellar: :any_skip_relocation, monterey:       "d67f10f4ab04a964ab795752fcce1f278678e633f9f9b39ce15bca4fb14c0e18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2c7664c34f83d86f2869bf8b36d729d357c2bf989c74d3e5baa1fc46383e121b"
  end

  depends_on "go" => :build

  on_linux do
    depends_on "gpgme" => :build
    depends_on "pkg-config" => :build
    depends_on "device-mapper"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    (testpath/"Dockerfile").write <<~EOS
      FROM alpine
      ENV test=homebrew-core
      RUN echo "hello"
    EOS

    assert_match "dive #{version}", shell_output("#{bin}/dive version")
    assert_match "Building image", shell_output("CI=true #{bin}/dive build .", 1)
  end
end
