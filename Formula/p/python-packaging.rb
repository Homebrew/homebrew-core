# This is an exception to Homebrew policy on Python libraries. See:
# https://github.com/Homebrew/homebrew-core/issues/167905#issuecomment-2328118401
class PythonPackaging < Formula
  desc "Core utilities for Python packages"
  homepage "https://packaging.pypa.io/"
  url "https://files.pythonhosted.org/packages/c3/75/ffb1dc0ed12352139fb4ca0e3fde4325a23e3d0f3f40efe89717bc4f557b/packaging-26.4.tar.gz"
  sha256 "c4b671c41ddb9bf26e543c37723610d28fb6bf7affc4da17cf048d419d2c062a"
  license any_of: ["Apache-2.0", "BSD-2-Clause"]

  bottle do
    manifest_sha256 "2c7823c6c60dcc51884f19c43665650f7999782bd84538acd945d7817b8573b7"
    sha256 cellar: :any_skip_relocation, all: "9ee62437879827ffd8db0f4da03f8d16afa4433e748f9016d6ba56de9b9dfe23"
  end

  depends_on "python@3.15" => [:build, :test]

  allow_network_access! :build

  def install
    system python3, "-m", "pip", "install", *std_pip_args(build_isolation: true), "."

    # Pure python installation can be used on different Python versions
    # Add symlinks to use on all externally-managed pythons
    extra_pythons = Keg.for(python3).to_formula.versioned_formulae.select { |f| f.version >= "3.12" }
    extra_site_packages_list = extra_pythons.map { |f| lib/"python#{f.version.major_minor}/site-packages" }
    python_version = Formula["python-freethreading"].version.major_minor
    extra_site_packages_list << (lib/"python#{python_version}t/site-packages")
    site_packages = prefix/Language::Python.site_packages(python3)
    site_packages.find.select(&:file?).each do |path|
      extra_site_packages_list.each do |extra_site_packages|
        (extra_site_packages/path.relative_path_from(site_packages)).dirname.install_symlink path
      end
    end
  end

  test do
    system python3, "-c", <<~PYTHON
      from packaging.version import Version, parse
      v1 = parse("1.0a5")
      v2 = Version("1.0")
      assert v1 < v2
    PYTHON

    # Check that the wheel is safe to use on all pythons
    wheel = prefix/Language::Python.site_packages(python3)/"packaging-#{version}.dist-info/WHEEL"
    assert_match(/^Tag: py3-none-any$/, wheel.read)
  end
end
