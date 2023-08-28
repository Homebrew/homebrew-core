class Orbiton < Formula
  desc "Editor"
  homepage "https://orbiton.zip/"
  url "https://github.com/xyproto/orbiton.git",
      tag:      "v2.64.1",
      revision: "d01e9de6baa386a08dd6fca6ad76047451fbfa18"
  license "BSD-3-Clause"
  version_scheme 1
  head "https://github.com/xyproto/orbiton.git"

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/xyproto/orbiton").install buildpath.children
    cd "src/github.com/xyproto/orbiton/v2" do
      system "go", "build", "-o", "o"

      bin.install "o"
      prefix.install_metafiles
    end
  end

  test do
    output = shell_output("#{bin}/o --version")
    assert_match(/Orbiton .*/m, output)
  end
end
