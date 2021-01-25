class Mg < Formula
  desc "Small Emacs-like editor"
  homepage "https://github.com/ibara/mg"
  url "https://github.com/ibara/mg/releases/download/mg-6.8.1/mg-6.8.1.tar.gz"
  sha256 "a4af7afa77fed691096be8e2ff0507cc6bdd8efe7255916f714168d02790044c"
  license all_of: [:public_domain, "ISC", :cannot_represent]
  version_scheme 1

  bottle do
    cellar :any_skip_relocation
    sha256 "d953ff7efb6a4fffedc3021dc85397ada7062a5af02a27ccd6480235c808d9f5" => :big_sur
    sha256 "5f981515a969a53ba0a0dfa6eb180d73a0e094d8dca0490edf0a7785ab49a2a8" => :arm64_big_sur
    sha256 "3dba473bffce8dbbd93c3b73e989348873317705b768cd9e920c8d4365caa5e6" => :catalina
    sha256 "c81adc2432c2e5f07faac951fe0f07407d0abc24234e6302acd55ac7e99bb501" => :mojave
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
