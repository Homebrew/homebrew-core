class Kubefwd < Formula
    desc "Bulk port forwarding Kubernetes services for local development"
    homepage "https://github.com/txn2/kubefwd"
    url "https://github.com/txn2/kubefwd.git"
    version "1.9.2"
    sha256 "3f49349f7de2c8f60ae4d1248be4f936c9082d2b23cf9fa093caef20a60685d4"
  
    depends_on "go@1.11" => :build
  
    def install
      bin.install "kubefwd"
    end
  
    test do
      assert_natch "Kubefwd version: 1.9.2", shell_output("#{bin}/kubefwd -h 2>&1")
    end
  end