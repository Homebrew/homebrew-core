class Nancy < Formula
    desc "Golang vulnerability auditor"
    homepage "https://github.com/sonatype-nexus-community/nancy"
    url "https://github.com/sonatype-nexus-community/nancy.git",
    :tag      => "0.0.1",
    :revision => "0ddc0132e8b231d26d25d4eb71d9f273e4b01e3e"
    head "https://github.com/sonatype-nexus-community/nancy.git"
  
    depends_on "go"
  
    def install
      ENV["GO_PATH"] = buildpath
      bin_path = buildpath/"src/github.com/sonatype-nexus-community/nancy"
      bin_path.install Dir["*"]
      cd bin_path do
        system "go", "build", "-o", bin/"nancy", "."
      end
    end
  
    test do
      assert_match "0.0.1", shell_output("#{bin}/nancy -version")
    end
  end
  