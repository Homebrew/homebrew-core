class AmdatuBootstrap < Formula
  desc "Bootstrapping OSGi development"
  homepage "https://www.amdatu.com/bootstrap/intro.html"
  url "https://bitbucket.org/amdatuadm/amdatu-bootstrap/downloads/bootstrap-bin-r9.zip"
  sha256 "937ef932a740665439ea0118ed417ff7bdc9680b816b8b3c81ecfd6d0fc4773b"

  bottle :unneeded

  depends_on :java => "1.8"

  def install
    libexec.install %w[amdatu-bootstrap bootstrap.jar conf]
    (bin/"amdatu-bootstrap").write_env_script libexec/"amdatu-bootstrap",
      Language::Java.java_home_env("1.8")
  end

  test do
    output = shell_output("#{bin}/amdatu-bootstrap --info")
    assert_match "Amdatu Bootstrap R9", output
  end
end
