class K2cli < Formula
  desc "CLI for K2"
  homepage "https://github.com/samsung-cnct/k2cli"
  url "https://github.com/samsung-cnct/k2cli/releases/download/1.0.5/k2cli_1.0.5_darwin_amd64.tar.gz"
  sha256 "7e5c0fcd1a696cdbdf0c9bab0035e1c6b336b3b8d81ad7d568fbe54743d67a55"

  depends_on "docker" => :run

  def install
    bin.install "k2cli"
  end

  test do
    # test that we can generate a config file.
    system bin/"k2cli", "generate", (testpath/"config.yaml")
  end
end
