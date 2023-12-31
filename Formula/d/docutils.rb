class Docutils < Formula
  desc "Text processing system for reStructuredText"
  homepage "https://docutils.sourceforge.io"
  url "https://downloads.sourceforge.net/project/docutils/docutils/0.20.1/docutils-0.20.1.tar.gz"
  sha256 "f08a4e276c3a1583a86dce3e34aba3fe04d02bba2dd51ed16106244e8a923e3b"
  license all_of: [:public_domain, "BSD-2-Clause", "GPL-3.0-or-later", "Python-2.0"]
  revision 1

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fa9cbcc947ce1576e508a8dfe24ba0ef19141ee8e068f8ae2055179aa303b24d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cba04ed0253c9a19fd605e2f8366797f612d3744d7899467307eac1394cf11ed"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "767da48c2d42fca594ee7684e0defa880d1449e0e3e97d53890442d6641e5984"
    sha256 cellar: :any_skip_relocation, sonoma:         "5cf8ababce162145e3bc7ac9332787d4f16dc19666970555937585e03c5fe8b7"
    sha256 cellar: :any_skip_relocation, ventura:        "88b0625f0e9f7f87254ee88e97de0248f6c21faac2de980cd00b33ab262f38d3"
    sha256 cellar: :any_skip_relocation, monterey:       "99112fc17faff857416bb41fe2c5d14c7e1b3d0dd86d9f86bffb7ab34aefd01f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "480c0b72303e68588d67dd37efc0b55d3971f67561c765f3947d1af96103d790"
  end

  depends_on "python-setuptools" => :build
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]

  def pythons
    deps.map(&:to_formula)
        .select { |f| f.name.start_with?("python@") }
        .sort_by(&:version)
  end

  def install
    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, "-m", "pip", "install", *std_pip_args, "."
    end

    bin.glob("*.py") do |f|
      bin.install_symlink f => f.basename(".py")
    end
  end

  def caveats
    <<~EOS
      To run front-end tools, you may need to `brew install #{pythons.last}`
    EOS
  end

  test do
    cp prefix/"README.txt", testpath
    mkdir_p testpath/"docs"
    touch testpath/"docs"/"header0.txt"
    system bin/"rst2man.py", testpath/"README.txt"
    system bin/"rst2man", testpath/"README.txt"
    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, "-c", "import docutils"
    end
  end
end
