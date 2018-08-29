class Mage < Formula
  desc "Make/rake-like build tool using Go"
  homepage "https://magefile.org"
  url "https://github.com/magefile/mage/archive/v2.2.0.tar.gz"
  sha256 "9a706d8b351bb395d3baca7ee98856a03f46a33ae3d884281c5841a9b8a4a924"

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    dir = buildpath/"src/github.com/magefile/mage"
    dir.install buildpath.children - [buildpath/".brew_home"]

    cd dir do
      system "go", "build", "-o", bin/"mage"
    end
  end

  test do
    cd testpath do
      system bin/"mage", "-init"

      # NOTE: install helper library used by mage template.  This allows the following test to run successfully.
      system "go", "get", "github.com/magefile/mage/mg"

      assert_match("installDeps", pipe_output(bin/"mage", "-l"))
    end
  end
end
