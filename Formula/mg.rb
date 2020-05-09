class Mg < Formula
  desc "Small Emacs-like editor"
  homepage "https://github.com/ibara/mg"
  url "https://github.com/ibara/mg/releases/download/mg-6.7/mg-6.7.tar.gz"
  sha256 "02583d90df743e994fb1e411befbd23488fd1eaeb82c9db1fd4957d1a8f1abde"
  version_scheme 1

  bottle do
    cellar :any_skip_relocation
    sha256 "5e1101814aad6dfb5191f3b0b8c2fab64b119f830275cf17a5d0ccf3b349cfb5" => :catalina
    sha256 "d4ba4bdd794bafa810faf9bd24d705bb5eb219f035039b8c01ee4702ad4ffefa" => :mojave
    sha256 "ce20159b78121c3806337165951d796b8a842cef21e05ef9d928152fd7e5feaf" => :high_sierra
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
