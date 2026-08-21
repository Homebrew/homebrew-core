class Decasify < Formula
  desc "Utility for casting strings to title-case according to locale-aware style guides"
  homepage "https://github.com/alerque/decasify"
  url "https://github.com/alerque/decasify/releases/download/v0.11.4/decasify-0.11.4.tar.zst"
  sha256 "37e56750c7ccbe725f44dd065c6dbc170f92afa950c335e7f8256f21ba3b8fcc"
  license "LGPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8f6984e5c6a88b14f0c82c3b726a14ab54dfa0ce824118af032bd9bf65549980"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "22ea4a70d1b78471a9bd978c3f706eacc1e2809cba9b7a42cd5d765c9efc5275"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f4713febbe2c420cd82d201d28481ca859f4edd89497338530555aa31345e355"
    sha256 cellar: :any_skip_relocation, sonoma:        "2991315a3c4330139406a1355a1be6131cdf94f93a21aab07351bff785cd81fe"
    sha256 cellar: :any,                 arm64_linux:   "1b16c31fd1ff05b83b43ee2152bcd6b00e296c74ca09d13e853b803cddd854c1"
    sha256 cellar: :any,                 x86_64_linux:  "29c14f6786b551c0e2e7839e05100bacb7a77e5b4b4542f7bbb4b63425b2291e"
  end

  head do
    url "https://github.com/alerque/decasify.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "jq" => :build, since: :sequoia

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "./bootstrap.sh" if build.head?
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    assert_match "decasify v#{version}", shell_output("#{bin}/decasify --version")
    assert_match "Ben ve İvan", shell_output("#{bin}/decasify -l tr -c title 'ben VE ivan'")
  end
end
