class Gcovr < Formula
  desc "Reports from gcov test coverage program"
  homepage "https://gcovr.com/"
  url "https://github.com/gcovr/gcovr/archive/4.1.tar.gz"
  sha256 "1ad8042fd4dc4c355fd7e605d395eefa2a59b1677dfdc308e0ef00083e8b37ee"
  head "https://github.com/gcovr/gcovr.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4c1f761c118737ad2f786b20433f8ffb62344ed0449ba4c57d3316c1e87dace4" => :catalina
    sha256 "375d5736d80f9843b2a77d86b365d123a472325c6c8cd3c68d065bce99d8c9bf" => :mojave
    sha256 "b5b3a5c643c84b547e6c2ae0c9db6cba7d53a8a081e080eb1efefcfd1f95b211" => :high_sierra
    sha256 "7cf8abff45bbea6e268fe4674c5f8ff2be1d4df413abf3068def0f07c2bc0c09" => :sierra
    sha256 "8044508fa650772d5d00cd83a8eacebf0cd910b2ced77e693809dbb8a0fdcb34" => :el_capitan
  end

  depends_on "python"

  resource "Jinja2" do
    url "https://files.pythonhosted.org/packages/56/e6/332789f295cf22308386cf5bbd1f4e00ed11484299c5d7383378cf48ba47/Jinja2-2.10.tar.gz"
    sha256 "f84be1bb0040caca4cea721fcbbbbd61f9be9464ca236387158b0feea01914a4"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/4d/de/32d741db316d8fdb7680822dd37001ef7a448255de9699ab4bfcbdf4172b/MarkupSafe-1.0.tar.gz"
    sha256 "a6be69091dac236ea9c6bc7d012beab42010fa914c459791d627dad4910eb665"
  end

  def install
    xy = Language::Python.major_minor_version "python3"
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python#{xy}/site-packages"
    resources.each do |r|
      r.stage do
        system "python3", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python#{xy}/site-packages"
    system "python3", *Language::Python.setup_install_args(libexec)

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    (testpath/"example.c").write "int main() { return 0; }"
    system "cc", "-fprofile-arcs", "-ftest-coverage", "-fPIC", "-O0", "-o",
                 "example", "example.c"
    assert_match "Code Coverage Report", shell_output("#{bin}/gcovr -r .")
  end
end
