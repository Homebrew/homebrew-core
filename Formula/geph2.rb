class Geph2 < Formula
  desc "Modular Internet censorship circumvention system"
  homepage "https://geph.io"
  url "https://github.com/geph-official/geph2/archive/v0.21.0.tar.gz"
  sha256 "38ab87945bdf22cb930b088539e0274281e492a2841ac620e90b912db1e0f0f1"

  bottle do
    cellar :any_skip_relocation
    sha256 "11a121a53802b0197c326309ae592106bf0c8ade75c33de968d93aff42a6c9f4" => :catalina
    sha256 "11a121a53802b0197c326309ae592106bf0c8ade75c33de968d93aff42a6c9f4" => :mojave
    sha256 "11a121a53802b0197c326309ae592106bf0c8ade75c33de968d93aff42a6c9f4" => :high_sierra
  end

  depends_on "go" => :build

  def install
    bin_path = buildpath/"src/github.com/geph-official/geph2"
    bin_path.install Dir["*"]
    cd bin_path/"cmd/geph-client" do
      ENV["CGO_ENABLED"] = "0"
      system "go", "build", "-o",
       bin/"geph-client", "-v", "-trimpath"
    end
  end

  test do
    assert_match "-username", shell_output("#{bin}/geph-client -h 2>&1", 2)
  end
end
