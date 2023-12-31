class PythonDistro < Formula
  desc "Linux OS platform information API"
  homepage "https://distro.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/fc/f8/98eea607f65de6527f8a2e8885fc8015d3e6f5775df186e443e0964a11c3/distro-1.9.0.tar.gz"
  sha256 "2fa77c6fd8940f116ee1d6b94a2f90b13b5ea8d019b98bc8bafdcabcdd9bdbed"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e8642e678649ff0d9af4a48fee6078a686d117ff36a038270a1763914d69b6e1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "03f2689eaa595e1752207a167f847325af9246bafa697841b90cea1ecef7223d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f8b1f428372af2a2ade9b8aeed3efb3b7ce8e74d96eb9e42c6f1fbd01e1d8c5a"
    sha256 cellar: :any_skip_relocation, sonoma:         "c766070c2db53b46bb497835ce64e89ce28281d7cf30fbfe8ba51b28a6486c83"
    sha256 cellar: :any_skip_relocation, ventura:        "5a4cfdef177c10e57613d3e91c568bed6786cfb5c420e5e3159e47031c857e79"
    sha256 cellar: :any_skip_relocation, monterey:       "8e2333fd74915a167dad7bf3cd9c2aeb54fb3c55863f296841ffa24843fc9e82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4b46d0485b3c7ca7f7bbbb9fe8242e8eb62fe6ce22a485d5ebd1fc667f2d82df"
  end

  depends_on "python-setuptools" => :build
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]

  def pythons
    deps.map(&:to_formula).sort_by(&:version).filter { |f| f.name.start_with?("python@") }
  end

  def install
    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, "-m", "pip", "install", *std_pip_args, "."
    end
  end

  def caveats
    <<~EOS
      To run `distro`, you may need to `brew install #{pythons.last}`
    EOS
  end

  test do
    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, "-c", "import distro"
    end

    version_json = JSON.parse(shell_output("#{bin}/distro --json"))["version_parts"]
    assert_match "build_number", version_json.to_s
  end
end
