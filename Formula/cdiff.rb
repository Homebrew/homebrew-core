class Cdiff < Formula
  desc "View colored diff with side by side and auto pager support"
  homepage "https://github.com/ymattw/cdiff"
  url "https://github.com/ymattw/cdiff/archive/1.0.tar.gz"
  sha256 "d9aa95299973cf25cba9d62a41df845ec4c5d391b9aca4d84f32fcefecccd846"
  head "https://github.com/ymattw/cdiff.git"

  bottle :unneeded

  depends_on "python" if MacOS.version <= :snow_leopard

  conflicts_with "colordiff", :because => "both install `cdiff` binaries"

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)
    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    diff_fixture = test_fixtures("test.diff").read
    assert_equal diff_fixture,
      pipe_output("#{bin}/cdiff -cnever", diff_fixture)
  end
end
