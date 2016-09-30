class AnsibleVaultTools < Formula
  desc "Tools for working with ansible-vault"
  homepage "https://github.com/building5/ansible-vault-tools/"
  url "https://github.com/building5/ansible-vault-tools/archive/v2.0.1.tar.gz"
  sha256 "ccbb255c22e2ed8af6ce9c8c3f855a0c0a983ca01784bedce7fa9629e66d2d5e"

  depends_on "ansible"
  depends_on "gnupg"

  def install
    bin.mkpath
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    system "ansible-vault-merge", "--help"
  end
end
