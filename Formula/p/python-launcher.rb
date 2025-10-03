class PythonLauncher < Formula
  desc "Launch your Python interpreter the lazy/smart way"
  homepage "https://github.com/brettcannon/python-launcher"
  url "https://github.com/brettcannon/python-launcher/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "6f868da0217b74e05775e7ebcbec4779ce12956728397ea57fd59c8529c56b6d"
  license "MIT"
  head "https://github.com/brettcannon/python-launcher.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "d27061039235be846906ba326bd45b8f80aeb0141be76073b509711d3fe28cb3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "3af917b0de67e1c9922fe684b03a9097297591db60a7991b8b7229851180f548"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0146c61c87ead63c9c650d43e12d5050001109ff75d9a7f410cd747c36a484bc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0f3708b110318c5c3596eb21ecd45390921eac40ae0201fcd262fdb476d9c744"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "09f64d96d2ebb83f2c9520ed535a77b8a3e4095f9a6c216de53553357242fee0"
    sha256 cellar: :any_skip_relocation, sonoma:         "04dae312adf70a9df94f79210ccf241013f58ce4aadf6cc29951c03cc16957b5"
    sha256 cellar: :any_skip_relocation, ventura:        "6b82f0178b46f14118b120598178b823812db7caecdf91b4e8822a4b8f143227"
    sha256 cellar: :any_skip_relocation, monterey:       "a3b9e42353ee19f5354a4e8f6b19c941926977398f021261b5cc3c11aa28d8d6"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "1a6564958fb0d3fa22689e1806b8dfdb86b25f0d243b6eb6e3a3b513c4a7eb87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "252b4ae87c81431c5f8929f9c41922224856ac40aaf928e2c7874ff5400acf3b"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    man1.install "man-page/py.1"
    fish_completion.install "completions/py.fish"
  end

  test do
    binary = testpath/"python3.6"
    binary.write("Fake Python 3.6 executable")
    with_env("PATH" => testpath) do
      assert_match("3.6 │ #{binary}", shell_output("#{bin}/py --list"))
    end
  end
end
