class Malcontent < Formula
  desc "Supply Chain Attack Detection, via context differential analysis and YARA"
  homepage "https://github.com/chainguard-dev/malcontent"
  url "https://github.com/chainguard-dev/malcontent/archive/refs/tags/v1.9.0.tar.gz"
  sha256 "fdeb67021d6bc459a497c0bdd368ad57887e123fb53b82f7fcca1e6ae3040c15"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "4b578de3e90f341a633c00d0fb734a927c9bd9fce379f5a469dfc242d0d1a903"
    sha256 cellar: :any,                 arm64_sonoma:  "88e3a321ad1b5b95bebedce2cb774e68482c909934538f73aeb0559d9e583524"
    sha256 cellar: :any,                 arm64_ventura: "6f6bc958daad98d78764f36117d705d893c124938af99b2319447e9b08c976e4"
    sha256 cellar: :any,                 sonoma:        "640a13dc82e5fabff6efe7ae2015e5b4b7b778c624e77791da5a717f81e4b364"
    sha256 cellar: :any,                 ventura:       "c411b381c02e58229be7e346fdae7c60cc5b20fdc6222f6fa1eef22619b6503c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "464dda654e59de858f5ca317e788b55cbe48478d466e014c8ff7b72a02d48f58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a1498c207bd012a369d9e811e8e83748731b45c168d98e73cdadfb766d8d9f77"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build
  depends_on "yara-x"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.BuildVersion=#{version}", output: bin/"mal"), "./cmd/mal"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mal --version")

    (testpath/"test.py").write <<~PYTHON
      import subprocess
      subprocess.run(["echo", "execute external program"])
    PYTHON

    assert_match "program — execute external program", shell_output("#{bin}/mal analyze #{testpath}")
  end
end
