class AmdatuBootstrap < Formula
  desc "Bootstrapping OSGi development"
  homepage "https://bitbucket.org/amdatuadm/amdatu-bootstrap/"
  url "https://bitbucket.org/amdatuadm/amdatu-bootstrap/downloads/bootstrap-bin-r9.zip"
  sha256 "937ef932a740665439ea0118ed417ff7bdc9680b816b8b3c81ecfd6d0fc4773b"
  license "Apache-2.0"
  revision 1

  livecheck do
    url "https://bitbucket.org/amdatuadm/amdatu-bootstrap/downloads/"
    regex(/href=.*?bootstrap[._-]v?(?:bin-)?r(\d+(?:\.\d+)*)(?:-bin)?\./i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "7efb4581ff91f9931f43d21974df335b66497e8d05488f91cdb9868a4c6ea0ac"
  end

  depends_on "openjdk@8"

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
