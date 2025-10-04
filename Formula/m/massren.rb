class Massren < Formula
  desc "Easily rename multiple files using your text editor"
  homepage "https://github.com/laurent22/massren"
  url "https://github.com/laurent22/massren/archive/refs/tags/v1.5.7.tar.gz"
  sha256 "7e7dd149bd3364235247268cc684b5a35badd9bee22f39960e075c792d037a8c"
  license "MIT"
  head "https://github.com/laurent22/massren.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cad349b22e28ef325892878894de36ea76f1c1235f0936ef7e3425c6dcf2933f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7b0b1c22e38a150df0076e405e76712522e6b73db270226c910afb585fc4bed2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e1b8bb5c09c3cdc3b6cd6489c960c488394e359cabbd933207c641da0a969abf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3a4d8c870ee69dc77582da2c058e5ab5630cfda919d5ed461fa4f1fe286d86a8"
    sha256 cellar: :any_skip_relocation, sonoma:        "a6a209d62fb3ae2ecef7d695c580dba2ab2de99b4052db0bd59ead450e35f0d6"
    sha256 cellar: :any_skip_relocation, ventura:       "2110bb0e290f470412225c98f0d6a5c6083c20371b4dc1e8b5f36c0a6779c084"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "70619f09b98eaf12e8c356accbebe73802aa58cf440d70b5bd921fa867904b25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4fb23682755ba48ba5f33e3ea6bacf7f24f2323531bb919ea7c037f0179a2977"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system bin/"massren", "--config", "editor", "nano"
    assert_match 'editor = "nano"', shell_output("#{bin}/massren --config")
  end
end
