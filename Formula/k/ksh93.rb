class Ksh93 < Formula
  desc "KornShell, ksh93"
  homepage "https://github.com/ksh93/ksh"
  url "https://github.com/ksh93/ksh/archive/refs/tags/v1.0.10.tar.gz"
  sha256 "9f4c7a9531cec6941d6a9fd7fb70a4aeda24ea32800f578fd4099083f98b4e8a"
  license "EPL-2.0"
  head "https://github.com/ksh93/ksh.git", branch: "dev"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "e4cdcf59bc35d8ac2dbca2bd189d14bee322bb306169324db049f263f58277e1"
    sha256 cellar: :any,                 arm64_sequoia:  "5deb3b81fd3f590988dd88c80311891ca93a33af176c47156a1451bd7aabac87"
    sha256 cellar: :any,                 arm64_sonoma:   "c19642595db560b792a462a2754cdd1c9dcf9cce1206f831e9445f364ddeee9d"
    sha256 cellar: :any,                 arm64_ventura:  "35617322f558cb0e43a0f265eefaffbe447061bc24acd75452b2b5b084e56acd"
    sha256 cellar: :any,                 arm64_monterey: "2f7f6d16223a34599d8f5d7a109e3c0b9bf16dbd98758b8c643d9c43ba40001d"
    sha256                               sonoma:         "b15cd1a4a1052c29217a92cdcc890755a1af17031b0375d2c48218e37de17ed3"
    sha256                               ventura:        "fd2c2ab5ef6b79db5b99b18775c36806ab45f06dbfde1a19dbba879c88ff02a3"
    sha256                               monterey:       "4a18d30f5bd6874f925b389150c77864955c33d546025ab87ba95dc36e6287be"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "a533071501bda03b7663eaf76acaee427fd6ad410521db8f3d42b349a4a8938c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6e1e57baceef185a21b476c489ec150cbf00729c4b0b31243dd13d5f560376b1"
  end

  def install
    ENV.append "LDFLAGS", "-Wl,-rpath,#{lib}"
    ENV.append "LDFLAGS", "-Wl,-headerpad_max_install_names" if OS.mac?

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
