class Qodem < Formula
  desc "Terminal emulator and BBS client"
  homepage "https://qodem.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/qodem/qodem/1.0.1/qodem-1.0.1.tar.gz"
  sha256 "dedc73bfa73ced5c6193f1baf1ffe91f7accaad55a749240db326cebb9323359"
  license :public_domain

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "62259c018c435331adcb0c9d99b72f119e03d4cb549a100e758f96deae273b8f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "82b1c05936cabb7c92111db07b6443f9dcf4313bb092321cdfb32b9b0866e675"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cf3db8bf2f510749816adf4d24e383033ac3211742e922788dd0b0686287985b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c88b2b10336d0562d9858744dac90f4f895efa643ae7441170a2c33fafd76c23"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "230b60c0f6dbd68eb6842acc073e21b0fb2bb5e4e47a8f37b2fd812980849c7f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0edd8a307de97c0844df4940c87ea88cfe68e5b41ca55e6c6d67f4b024b31477"
    sha256 cellar: :any_skip_relocation, sonoma:         "e8d54c0a6aeddabfb41011dc78dd6ad6a5c3363a89574cefb7f93835ff54c335"
    sha256 cellar: :any_skip_relocation, ventura:        "eb099f141c43635088e5069c8f519aa88100348db0172f1f54847de32a6c45b8"
    sha256 cellar: :any_skip_relocation, monterey:       "ded91d17b85bfa34b3cd3eb01a338f19ed91711a2c4fdea71d5543cc3953c2ab"
    sha256 cellar: :any_skip_relocation, big_sur:        "ac2537f733ed6952656aec3016302414b37166b64b2d89836f17354008276f73"
    sha256 cellar: :any_skip_relocation, catalina:       "14491121c60a5368cf41e4cab4df43bd918f31342f8aedf7e43241a3e49b22b7"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "6e3c2992c032736b98f58b50eaa897b282a3843012fc22371dd43bd93cd4ed7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "19414f9b69d7423a5f2ab1ecb2690bf1bd285f96832d151835741867f22f2e6e"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  uses_from_macos "ncurses"

  def install
    system "./configure", *std_configure_args,
                          "--disable-silent-rules",
                          "--disable-gpm",
                          "--disable-sdl",
                          "--disable-serial",
                          "--disable-upnp",
                          "--disable-x11"
    system "make", "install"
  end

  test do
    system bin/"qodem", "--exit-on-completion", "--capfile", testpath/"qodem.out", "uname"
    assert_match OS.kernel_name, File.read(testpath/"qodem.out")
  end
end
