class Ksh93 < Formula
  desc "KornShell, ksh93"
  homepage "https://github.com/ksh93/ksh#readme"
  url "https://github.com/ksh93/ksh/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "4cbbee459df591426fea9e1705fa3200d168faf800451544d04fdb7013e33468"
  license "EPL-2.0"
  head "https://github.com/ksh93/ksh.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d493892e1f7aafb3a6ae418d7a33ee61356afa59cd0537cf70a50c859cd53c42"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e805a8bd5bc0ca280d4b2faf31e1e187278302c7ba3306c196209ccf2aa1f01e"
    sha256 cellar: :any_skip_relocation, monterey:       "b6461ac57bce670a56733ce0394fe6f1881a9a6708b0f69a5f97207b49c93a54"
    sha256 cellar: :any_skip_relocation, big_sur:        "6c4329075e1255282b965e5967a226391f909a5c02fc5b8b498171e536776774"
    sha256 cellar: :any_skip_relocation, catalina:       "a52de9fc3758ce49abe666bb334d906b6d955e71edcde58913da148ea867000d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cea82cf12c20809cc2313d40eb41f154ef1b01cd0287c6f05dc9d5dd549f8381"
  end

  def install
    system "bin/package", "verbose", "make"
    system "bin/package", "verbose", "install", prefix
    %w[ksh93 rksh rksh93].each do |alt|
      bin.install_symlink "ksh" => alt
      man1.install_symlink "ksh.1" => "#{alt}.1"
    end
    doc.install "ANNOUNCE"
    doc.install %w[COMPATIBILITY README RELEASE TYPES].map { |f| "src/cmd/ksh93/#{f}" }
  end

  test do
    system "#{bin}/ksh93 -c 'A=$(((1./3)+(2./3)));test $A -eq 1'"
  end
end
