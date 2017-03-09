class Blackbox < Formula
  desc "Safely store secrets in Git/Mercurial/Subversion"
  homepage "https://github.com/StackExchange/blackbox"
  url "https://github.com/StackExchange/blackbox/archive/v1.20170309.tar.gz"
  sha256 "c5f75252ab298b6b7b12d9407228a29112df85a228d7ee56a7bc6b0c807da284"

  bottle :unneeded

  depends_on :gpg => :run

  def install
    libexec.install Dir["bin/*"]
    bin.write_exec_script Dir[libexec/"*"].select { |f| File.executable? f }
  end

  test do
    Gpg.create_test_key(testpath)
    system "git", "init"
    system bin/"blackbox_initialize", "yes"
    add_created_key = shell_output("#{bin}/blackbox_addadmin Testing 2>&1")
    assert_match "<testing@foo.bar>", add_created_key
  end
end
