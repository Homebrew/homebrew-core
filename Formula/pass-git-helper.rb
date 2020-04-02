class PassGitHelper < Formula
  include Language::Python::Virtualenv

  desc "Git credential helper interfacing with pass"
  homepage "https://github.com/languitar/pass-git-helper"
  url "https://github.com/languitar/pass-git-helper/archive/v1.1.0.tar.gz"
  sha256 "85c9e2f1f544227da9129503d91ce5d502be127c83ad24cbc6dc8ba3ab746b8e"

  depends_on "pass"
  depends_on "python@3.8"

  resource "pyxdg" do
    url "https://files.pythonhosted.org/packages/47/6e/311d5f22e2b76381719b5d0c6e9dc39cd33999adae67db71d7279a6d70f4/pyxdg-0.26.tar.gz"
    sha256 "fe2928d3f532ed32b39c32a482b54136fe766d19936afc96c8f00645f9da1a06"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"password-store/homebrew/pass-git-helper-test").write <<~EOS
      test_password
      test_username
    EOS

    (testpath/"bin/pass").write <<~EOS
      #!/bin/sh
      if [ $1 = show ]; then
        cat #{testpath}/password-store/$2
      fi
    EOS
    chmod 0755, testpath/"bin/pass"

    ENV.prepend_path "PATH", testpath/"bin"

    (testpath/"config.ini").write <<~EOS
      [github.com*]
      target=homebrew/pass-git-helper-test
    EOS

    (testpath/"credential").write <<~EOS
      protocol=https
      host=github.com
      path=homebrew/homebrew-core

    EOS

    s = shell_output("#{bin}/pass-git-helper -m #{testpath}/config.ini get < #{testpath}/credential")
    assert_match "password=test_password\nusername=test_username", s
  end
end
