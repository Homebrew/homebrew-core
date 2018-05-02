class Atdtool < Formula
  desc "Command-line interface for After the Deadline language checker"
  homepage "https://github.com/lpenz/atdtool"
  url "https://github.com/lpenz/atdtool/archive/upstream/1.3.3.tar.gz"
  sha256 "3e928721388cf6f58b7e663ebc5508f26d180b1c07d5b8119212356c66e57fe8"

  bottle do
    cellar :any_skip_relocation
    sha256 "ac22c0d462774d7807e99dca779d47ab586afa210366a7be5568da76e378e4b9" => :high_sierra
    sha256 "ac22c0d462774d7807e99dca779d47ab586afa210366a7be5568da76e378e4b9" => :sierra
    sha256 "ac22c0d462774d7807e99dca779d47ab586afa210366a7be5568da76e378e4b9" => :el_capitan
  end

  depends_on "python@2"

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)
    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
    prefix.install libexec/"share"
  end

  test do
    system "#{bin}/atdtool", "--help"
  end
end
