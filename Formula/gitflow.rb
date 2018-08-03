class Gitflow < Formula
    desc "CLI to create, list and remove Github repositories"
    homepage "https://github.com/fabianschilf94/gitflow"
    url "http://www.mediafire.com/file/mchul9hxnuzyp37/gitflow-1.0.0.tar.gz"
    sha256 "337eca044c7653e876f96f8c23c184f817abf08f7d735661c9115eb4d9f8a7b6"
  
    def install
      bin.install "dist/gitflow"
    end
  
    test do
      system "false"
    end
  end
  