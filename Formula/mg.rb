class Mg < Formula
  desc "Small Emacs-like editor"
  homepage "https://github.com/ibara/mg"
  url "https://github.com/ibara/mg/releases/download/mg-6.7/mg-6.7.tar.gz"
  sha256 "02583d90df743e994fb1e411befbd23488fd1eaeb82c9db1fd4957d1a8f1abde"
  version_scheme 1

  bottle do
    cellar :any_skip_relocation
    sha256 "44271237cfb495988cd88029e0ac465a46e14bdb583ac09c1acdf73f95bd4fc4" => :catalina
    sha256 "ac5ac7054d3feb7aaef8746482678e66380893958299a36eeff1101cfa407d92" => :mojave
    sha256 "dfff27703d404052738009ab8c19a6d94b3a784c346962001eb80fa5cd9de4c4" => :high_sierra
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"command.sh").write <<~EOS
      #!/usr/bin/expect -f
      set timeout -1
      spawn #{bin}/mg
      match_max 100000
      send -- "\u0018\u0003"
      expect eof
    EOS
    chmod 0755, testpath/"command.sh"

    system testpath/"command.sh"
  end
end
