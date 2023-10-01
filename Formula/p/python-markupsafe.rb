class PythonMarkupsafe < Formula
  desc "Implements a XML/HTML/XHTML Markup safe string for Python"
  homepage "https://palletsprojects.com/p/markupsafe/"
  url "https://files.pythonhosted.org/packages/6d/7c/59a3248f411813f8ccba92a55feaac4bf360d29e2ff05ee7d8e1ef2d7dbf/MarkupSafe-2.1.3.tar.gz"
  sha256 "af598ed32d6ae86f1b747b82783958b1a4ab8f617b06fe68795c7f026abbdcad"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8dc5abda8181e435fdb3ea78288b802095a01af39161b949feb482a2a186c525"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "23fb7df7e480ae29fa2765130813f0531a5ce26467a80adc062ceae107390a61"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e87fb37ae58cb9c88427a03873ea9a8e3947dc85102adc3304d9073cc4861c19"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ba45e541895067ade3baffbc6e408437ec9abffe8f0aad81e4cce445af45df26"
    sha256 cellar: :any_skip_relocation, sonoma:         "7b7432a4eba26532fa3dffe7104ece9ba1637019a1cf13b934bcc9f22ddef971"
    sha256 cellar: :any_skip_relocation, ventura:        "c68f2269d60ff7c5795f823baca722c522e034fad92591a8c6b0a46b102144a5"
    sha256 cellar: :any_skip_relocation, monterey:       "938586a6ab469083c2bfafc7197439a8342f35541e865d2df375342559fb6194"
    sha256 cellar: :any_skip_relocation, big_sur:        "a752771f37e5d6dda3bcc18693a3b61d4e407cefb4d534fce0f113e2f7c9f8c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "81ec603d54ee57cdb6d26e68e4dac2598139747f2540cc032aaf59f5d937541d"
  end

  depends_on "python@3.10" => [:build, :test]
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.9" => [:build, :test]

  def pythons
    deps.map(&:to_formula).sort_by(&:version).filter { |f| f.name.start_with?("python@") }
  end

  def install
    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, "-m", "pip", "install", *std_pip_args, "."
    end
  end

  test do
    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, "-c", "from markupsafe import escape"
    end
  end
end
