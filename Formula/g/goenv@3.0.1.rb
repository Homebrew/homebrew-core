class GoenvAT301 < Formula
  desc "Go version management"
  homepage "https://github.com/go-nv/goenv"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/go-nv/goenv/releases/download/3.0.1/goenv_3.0.1_darwin_arm64.tar.gz"
      sha256 "cd9a316f2bcb71167eddcfc6e29d0703bb1824b4700fdaa12b9e6268980f1a69"
    end
    on_intel do
      url "https://github.com/go-nv/goenv/releases/download/3.0.1/goenv_3.0.1_darwin_amd64.tar.gz"
      sha256 "c896d905d771166167dff0d408f9411f796f10b4b5e52aa4c8f7de3738f8aa1a"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/go-nv/goenv/releases/download/3.0.1/goenv_3.0.1_linux_arm64.tar.gz"
      sha256 "9712533fec373f20580dea6bfda605e9d58c1e51c9795d15588bfd178333d4bb"
    end
    on_intel do
      url "https://github.com/go-nv/goenv/releases/download/3.0.1/goenv_3.0.1_linux_amd64.tar.gz"
      sha256 "548560754b65aafb0f8ce43c6ef71d1a8e28e0565d631fa06bfdccb31628f6ea"
    end
  end

  version "3.0.1"

  livecheck do
    url :homepage
    regex(/^v?(3\.\d+\.\d+)$/i)
  end

  conflicts_with "goenv", because: "both install `goenv` binaries"

  def install
    bin.install "goenv"
    prefix.install "docs"
    doc.install "README.md", "LICENSE"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goenv --version")
  end
end
