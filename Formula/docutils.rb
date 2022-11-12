class Docutils < Formula
  desc "Text processing system for reStructuredText"
  homepage "https://docutils.sourceforge.io"
  url "https://downloads.sourceforge.net/project/docutils/docutils/0.19/docutils-0.19.tar.gz"
  sha256 "33995a6753c30b7f577febfc2c50411fec6aac7f7ffeb7c4cfe5991072dcf9e6"
  license all_of: [:public_domain, "BSD-2-Clause", "GPL-3.0-or-later", "Python-2.0"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "10bee4ba96884f6b1b1bcfb9ae78f7ff7d923707e357bb9e4f3682a7ba8aebdc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b784e47113758f9c47cfa4567a26d862fc9d0921bd6b63565b093913f86607b4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b784e47113758f9c47cfa4567a26d862fc9d0921bd6b63565b093913f86607b4"
    sha256 cellar: :any_skip_relocation, ventura:        "198f0738d9631da591e9da489c80b763dd7a9a343ff9035e9b5060988e45ca2c"
    sha256 cellar: :any_skip_relocation, monterey:       "ae5ef91d15f574fd9adeb50a5b1023c45f56fb7eed85ac270fdd0fcc401b41e3"
    sha256 cellar: :any_skip_relocation, big_sur:        "ae5ef91d15f574fd9adeb50a5b1023c45f56fb7eed85ac270fdd0fcc401b41e3"
    sha256 cellar: :any_skip_relocation, catalina:       "ae5ef91d15f574fd9adeb50a5b1023c45f56fb7eed85ac270fdd0fcc401b41e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6a51a4a455f0f93c4020aa5c692df0cbee810a4967ca38708591cb91d584fe7c"
  end

  depends_on "python@3.10" => [:build, :test]
  depends_on "python@3.11" => [:build, :test]

  def pythons
    deps.map(&:to_formula)
        .select { |f| f.name.match?(/^python@3\.\d+$/) }
  end

  def install
    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, *Language::Python.setup_install_args(libexec, python_exe)

      site_packages = Language::Python.site_packages(python_exe)
      pth_contents = "import site; site.addsitedir('#{libexec/site_packages}')\n"
      (prefix/site_packages/"homebrew-docutils.pth").write pth_contents

      pyversion = Language::Python.major_minor_version(python_exe)
      Dir.glob("#{libexec}/bin/*.py") do |f|
        bname = File.basename(f, ".py")
        bin.install_symlink f => "#{bname}-#{pyversion}"
        bin.install_symlink f => "#{bname}.py-#{pyversion}"
      end

      next unless python == pythons.max_by(&:version)

      # The newest one is used as the default
      Dir.glob("#{libexec}/bin/*.py") do |f|
        bname = File.basename(f, ".py")
        bin.install_symlink f => bname
        bin.install_symlink f => "#{bname}.py"
      end
    end
  end

  test do
    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      pyversion = Language::Python.major_minor_version(python_exe)
      system "#{bin}/rst2man.py-#{pyversion}", "#{prefix}/HISTORY.txt"
      system "#{bin}/rst2man-#{pyversion}", "#{prefix}/HISTORY.txt"
    end

    system "#{bin}/rst2man.py", "#{prefix}/HISTORY.txt"
    system "#{bin}/rst2man", "#{prefix}/HISTORY.txt"
  end
end
