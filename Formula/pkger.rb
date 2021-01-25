class Pkger < Formula
  desc "Embed static files in Go binaries (replacement for gobuffalo/packr)"
  homepage "https://github.com/markbates/pkger"
  url "https://github.com/markbates/pkger/archive/v0.17.1.tar.gz"
  sha256 "da775b5ec5675f0db75cf295ff07a4a034ba15eb5cc02d278a5767f387fb8273"
  license "MIT"
  head "https://github.com/markbates/pkger.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5e8e1ed6fb7d25ba269bc5aff1a0669f745abbc3131960f82f5ea8590fe21ccd" => :big_sur
    sha256 "602233db9e62865199a0e6dda19d96e258a43c596ef588d6305b62f43c09c577" => :arm64_big_sur
    sha256 "6fff2fd267b9f7b73cd88251b61d823a6ea92c318fbbb2de16f4a21aa8c7ee59" => :catalina
    sha256 "ef5c45bad9d022fe1752b831e7162f196f3c76f3b4c28a5e880d6638a6e6acfd" => :mojave
  end

  depends_on "go"

  def install
    system "go", "build", *std_go_args, "./cmd/pkger"
  end

  test do
    mkdir "test" do
      system "go", "mod", "init", "example.com"
      system bin/"pkger"
      assert_predicate testpath/"test/pkged.go", :exist?
      assert_equal "{\n \".\": null\n}\n", shell_output("#{bin}/pkger parse")
    end
  end
end
