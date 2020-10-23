class Convox < Formula
  desc "Command-line interface for the Convox PaaS"
  homepage "https://convox.com/"
  url "https://github.com/convox/convox/archive/3.0.43.tar.gz"
  sha256 "65dd83b2ac9384b95893941f2392de8c87a462438d463834805a82ee48f62df6"
  license "Apache-2.0"
  version_scheme 1

  bottle do
    cellar :any_skip_relocation
    sha256 "26ab60cdaf71fb8c4e0bbb474d79e4e285102b92f2ed0511fdfc060294a01a06" => :catalina
    sha256 "0745086dd49b0443929dcfd9175483dd6b23a9e38f1de7a5f5cca8a3923dc7e2" => :mojave
    sha256 "1c0f8867746a448f0b3825a1245ffa83e7328120279b43e64e4be7d39f7e4d63" => :high_sierra
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
