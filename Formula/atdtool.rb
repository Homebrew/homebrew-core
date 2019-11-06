class Atdtool < Formula
  desc "Command-line interface for After the Deadline language checker"
  homepage "https://github.com/lpenz/atdtool"
  url "https://github.com/lpenz/atdtool/archive/upstream/1.3.3.tar.gz"
  sha256 "3e928721388cf6f58b7e663ebc5508f26d180b1c07d5b8119212356c66e57fe8"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "f046c7fce18236356a4e4ae42cdf6f06b338c411511973efd3ce883116fa6c37" => :catalina
    sha256 "70d3f21f1dc1ee76fa55fcb3d4cd5369300c8d361031267fb25f6426b13bdce9" => :mojave
    sha256 "2de45317e5c51f1fcb7365d038e667fcbf48f333af9c49eb0a27ddce2d2b1e57" => :high_sierra
    sha256 "2de45317e5c51f1fcb7365d038e667fcbf48f333af9c49eb0a27ddce2d2b1e57" => :sierra
  end

  depends_on "python"

  def install
    xy = Language::Python.major_minor_version "python3"
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python#{xy}/site-packages"
    system "python3", *Language::Python.setup_install_args(libexec)
    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
    prefix.install libexec/"share"
  end

  test do
    system "#{bin}/atdtool", "--help"
  end
end
