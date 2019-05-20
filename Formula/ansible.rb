class Ansible < Formula
  include Language::Python::Virtualenv

  desc "Automate deployment, configuration, and upgrading"
  homepage "https://www.ansible.com/"
  url "https://releases.ansible.com/ansible/ansible-2.8.0.tar.gz"
  sha256 "7234dd7d89150dc5bf035bc1ec3c084a8a0699d89e1c9b06b2af6dd34b2ef3ae"
  revision 1
  head "https://github.com/ansible/ansible.git", :branch => "devel"

  bottle do
    cellar :any
    sha256 "fd9e8fa0fff74f52ca679b8b3b2adf5eb7ad1767930e90bf32b2a95b46eab738" => :mojave
    sha256 "aa366096d899a50ce520d5370ea94d507355cc66ed70c56ed83ccd33892729d7" => :high_sierra
    sha256 "4cb378562e15a743e8dc4ed7e47eee1da8a99838647c7783d13fe12bcde6ca15" => :sierra
  end

  depends_on "python"

  def install
    venv = virtualenv_create(libexec, "python3")
    system libexec/"bin/pip", "install", "-v", "--no-binary", ":all:",
                              "--ignore-installed", buildpath
    system libexec/"bin/pip", "uninstall", "-y", "ansible"
    venv.pip_install_and_link buildpath
    man1.install Dir["docs/man/man1/*.1"]
  end

  test do
    ENV["ANSIBLE_REMOTE_TEMP"] = testpath/"tmp"
    (testpath/"playbook.yml").write <<~EOS
      ---
      - hosts: all
        gather_facts: False
        tasks:
        - name: ping
          ping:
    EOS
    (testpath/"hosts.ini").write "localhost ansible_connection=local\n"
    system bin/"ansible-playbook", testpath/"playbook.yml", "-i", testpath/"hosts.ini"
  end
end
