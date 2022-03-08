class AnsibleVaultPassClient < Formula
  desc "Ansible vault password client script to integrate your password manager"
  homepage "https://github.com/bkahlert/ansible-vault-pass-client"
  url "https://github.com/bkahlert/ansible-vault-pass-client/releases/download/v0.1.0/ansible-vault-pass-client.tar.gz"
  sha256 "b88b782848aa55bb40ed297890a131093784d8ac62c4f1c6a2d983038e591a81"
  license "MIT"

  depends_on "lastpass-cli" => :test

  def install
    bin.install "ansible-vault-pass-client"
  end

  test do
    assert_equal "", shell_output(
      "#{bin}/ansible-vault-pass-client",
      1,
    ).strip
    assert_equal "", shell_output(
      "ANSIBLE_VAULT_PASS_CLIENT=invalid #{bin}/ansible-vault-pass-client",
      1,
    ).strip
    assert_equal "", shell_output(
      "ANSIBLE_VAULT_PASS_CLIENT=invalid #{bin}/ansible-vault-pass-client --vault-id label",
      1,
    ).strip
    assert_equal "", pipe_output(
      "ANSIBLE_VAULT_PASS_CLIENT=lastpass
 ANSIBLE_VAULT_PASS_CLIENT_USERNAME=john.doe@example.com
 #{bin}/ansible-vault-pass-client",
      "password\n",
      1,
    ).strip
  end
end
