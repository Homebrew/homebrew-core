class Choose < Formula
  desc "Make choices on the command-line"
  homepage "https://github.com/geier/choose"
  url "https://github.com/geier/choose/archive/v0.1.0.tar.gz"
  sha256 "d09a679920480e66bff36c76dd4d33e8ad739a53eace505d01051c114a829633"
  license "MIT"
  revision 4
  head "https://github.com/geier/choose.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8cc4e4eaabc3341ed4728d11d5cee96f7954d6d24bef173d1848884581ddf1f9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2b715be8453394e1f1931994780ad42075c05d483d24257ef1226054ff2b450e"
    sha256 cellar: :any_skip_relocation, monterey:       "ed6b3c62ea97cf196ce3843bb855c75539e756e6a582d48957cce31286a0626d"
    sha256 cellar: :any_skip_relocation, big_sur:        "b22b7b549f0f9621163fc1b6b5923a2de0f79177686e8747ffb1b71201e979d7"
    sha256 cellar: :any_skip_relocation, catalina:       "37aa7b900d689cedd0c834703663f782082f66595d9b84f27405180832311385"
    sha256 cellar: :any_skip_relocation, mojave:         "9d2fb7796ec1e3b55838d9fd932f91dae4c3268f343d1d8cba2cac7ac77b04da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9241612ee60fcabf7fa8471843592f7063fb28f32a92e12dad97c1ab8774041f"
  end

  depends_on "python@3.10"

  conflicts_with "choose-gui", because: "both install a `choose` binary"
  conflicts_with "choose-rust", because: "both install a `choose` binary"

  resource "urwid" do
    url "https://files.pythonhosted.org/packages/45/dd/d57924f77b0914f8a61c81222647888fbb583f89168a376ffeb5613b02a6/urwid-2.1.0.tar.gz"
    sha256 "0896f36060beb6bf3801cb554303fef336a79661401797551ba106d23ab4cd86"
  end

  def install
    xy = Language::Python.major_minor_version "python3"
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python#{xy}/site-packages"

    resource("urwid").stage do
      system "python3", *Language::Python.setup_install_args(libexec)
    end

    bin.install "choose"

    bin.env_script_all_files(libexec/"bin", PYTHONPATH: ENV["PYTHONPATH"])
  end

  test do
    # There isn't really a better test than that the executable exists
    # and is executable because you can't run it without producing an
    # interactive selection ui.
    assert_predicate bin/"choose", :executable?
  end
end
