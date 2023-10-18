class Cgrep < Formula
  desc "Context-aware grep for source code"
  homepage "https://github.com/awgn/cgrep"
  url "https://github.com/awgn/cgrep/archive/v8.1.1.tar.gz"
  sha256 "de11b252c5a917909a0eac473843368655efc0f3cea30beea2aedeec3069d54e"
  license "GPL-2.0-or-later"
  head "https://github.com/awgn/cgrep.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "72fce3bd6ddd8fcd4c61523f30f89ae170ae0f12a5b120f28ae88787d4dd1ee2"
    sha256 cellar: :any,                 arm64_ventura:  "80ce6bd6ea41b234a641e2f375d093622f9297752a1d5fb4ab144ed364b76fce"
    sha256 cellar: :any,                 arm64_monterey: "83e88aaaa16832298b9bd0197974896f45286d9b82a176a2e4ae66b678767212"
    sha256 cellar: :any,                 sonoma:         "7ce5b54f71a327cfae61dc77f4b06c4d5da252c6a8ed80e6cb1c05bab649f905"
    sha256 cellar: :any,                 ventura:        "2f0f21f024af1cf96bc1b04db9c8ad4361d106f79a8af0aeae8843eef1f25263"
    sha256 cellar: :any,                 monterey:       "bb1ec88e8d9420460c7a24c418146771ad300ef0faea774a88b6d67de7b8956c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4e1622103466e9301eb288b5c465bf5a519a048bb689d85c9fc9fe2a4df074a4"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@9.4" => :build
  depends_on "pkg-config" => :build
  depends_on "pcre"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end

  test do
    (testpath/"t.rb").write <<~EOS
      # puts test comment.
      puts "test literal."
    EOS

    assert_match ":1", shell_output("#{bin}/cgrep --count --comment test t.rb")
    assert_match ":1", shell_output("#{bin}/cgrep --count --literal test t.rb")
    assert_match ":1", shell_output("#{bin}/cgrep --count --code puts t.rb")
    assert_match ":2", shell_output("#{bin}/cgrep --count puts t.rb")
  end
end
