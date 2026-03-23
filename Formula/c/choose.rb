class Choose < Formula
  include Language::Python::Shebang

  desc "Make choices on the command-line"
  homepage "https://github.com/geier/choose"
  url "https://github.com/geier/choose/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "d09a679920480e66bff36c76dd4d33e8ad739a53eace505d01051c114a829633"
  license "MIT"
  revision 4
  head "https://github.com/geier/choose.git", branch: "master"

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b4cd084aeff66d38306336992370937b0f8473abd64f70c8561145df065581ac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3057d3a685e175581c474a109b02b02e9ebd3cf5e4ab50d0319611de5446ce18"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bded43dc4b0b911ac3259b481dfb745b08d554e293a0467b15b5bcc4e4357c57"
    sha256 cellar: :any_skip_relocation, sonoma:        "7a48f740c534a14757cf6f5b72b233ce9923b266557d55eb43dd31e063e171fa"
    sha256 cellar: :any_skip_relocation, ventura:       "5b1c0d8199073bcd41b9edffd02784c4fe752388d3c53f4a2240aef48ce0fcfe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "74f310201e1c96729b74ec6d9df81f518b7dfc17b8eb57cfef044ef00008f8fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d4b42fd68579b38ed93b464f8e309b6642c884cae2f1281bcb576b678929945b"
  end

  deprecate! date: "2024-05-19", because: :unmaintained
  disable! date: "2025-05-19", because: :unmaintained

  depends_on "python@3.13"

  resource "urwid" do
    url "https://files.pythonhosted.org/packages/5f/cf/2f01d2231e7fb52bd8190954b6165c89baa17e713c690bdb2dfea1dcd25d/urwid-2.2.2.tar.gz"
    sha256 "5f83b241c1cbf3ec6c4b8c6b908127e0c9ad7481c5d3145639524157fc4e1744"
  end

  def install
    python3 = "python3.13"
    ENV.prepend_create_path "PYTHONPATH", libexec/Language::Python.site_packages(python3)

    resource("urwid").stage do
      system python3, "-m", "pip", "install", *std_pip_args(prefix: libexec, build_isolation: true), "."
    end

    bin.install "choose"
    rewrite_shebang detected_python_shebang, bin/"choose"
    bin.env_script_all_files(libexec/"bin", PYTHONPATH: ENV["PYTHONPATH"])
  end

  test do
    assert_predicate bin/"choose", :executable?

    # [Errno 6] No such device or address: '/dev/tty'
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    assert_equal "homebrew-test", pipe_output(bin/"choose", "homebrew-test\n").strip
  end
end
