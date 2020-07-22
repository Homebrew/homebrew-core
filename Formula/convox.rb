class Convox < Formula
  desc "Command-line interface for the Convox PaaS"
  homepage "https://convox.com/"
  url "https://github.com/convox/convox/archive/3.0.35.tar.gz"
  sha256 "72ac360ac2e45e1720ee47a871054eb0adb81d5253705eca6b0f9c7a0c000f10"
  license "Apache-2.0"
  version_scheme 1

  bottle do
    cellar :any_skip_relocation
    sha256 "df1035cd54911a91ffce8643d8b7579af6e3910b550247649954d03a74b1c514" => :catalina
    sha256 "cabcc21cb64f935163aec20f9900b0c42e2c785fe88a5657934f12dcb0240386" => :mojave
    sha256 "722c6cfdded1d9b799e6f50f60bb82c4a87816cec7564ba0c52d27ff0a1ae78b" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-mod=vendor", "-ldflags=-X main.version=#{version}",
            "-o", bin/"convox", "-v", "./cmd/convox"
    prefix.install_metafiles
  end

  test do
    assert_equal "Authenticating with localhost... ERROR: invalid login\n",
      shell_output("#{bin}/convox login -t invalid localhost 2>&1", 1)
  end
end
