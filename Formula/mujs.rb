class Mujs < Formula
  desc "Embeddable Javascript interpreter"
  homepage "https://www.mujs.com/"
  # use tag not tarball so the version in the pkg-config file isn't blank
  url "https://github.com/ccxvii/mujs.git",
      :tag      => "1.0.6",
      :revision => "14dc9355bd71818cf01c1c690c1c91a0978ea9b8"
  head "https://github.com/ccxvii/mujs.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8c318a1b2f86b2b1e0f960843c60af7e650bf8780049618151b4b4906de66996" => :catalina
    sha256 "f72a17230b0e05824d76d355ea9d6950411194955af3322a908146601516baa9" => :mojave
    sha256 "82a44b3406b0bdbf9f0aaa895c7dc6b1a0f2b31c423317c148b7da5c3c973ff8" => :high_sierra
    sha256 "de680f18725e4e787cdd6a22d0a7e2ba2e2fc818171726b50068075624e8eb8e" => :sierra
  end

  def install
    system "make", "release"
    system "make", "prefix=#{prefix}", "install"
  end

  test do
    (testpath/"test.js").write <<~EOS
      print('hello, world'.split().reduce(function (sum, char) {
        return sum + char.charCodeAt(0);
      }, 0));
    EOS
    assert_equal "104", shell_output("#{bin}/mujs test.js").chomp
  end
end
