class Clive < Formula
  desc "Automates terminal operations"
  homepage "https://github.com/koki-develop/clive"
  url "https://github.com/koki-develop/clive/archive/refs/tags/v0.12.13.tar.gz"
  sha256 "0cad5cb387d02120c9ffdca84e8fe2d1a94abc3212ae14ecb39c403dfa43f06b"
  license "MIT"
  head "https://github.com/koki-develop/clive.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f8453e96034ffae1201417b2f0fc748fcc923ece46ade09b2ec7a8673e1e8196"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f8453e96034ffae1201417b2f0fc748fcc923ece46ade09b2ec7a8673e1e8196"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f8453e96034ffae1201417b2f0fc748fcc923ece46ade09b2ec7a8673e1e8196"
    sha256 cellar: :any_skip_relocation, sonoma:        "b11df80e6486a90008055d418d3286a8e29d3f59da8450d31edf542f1a25b488"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ab130a9b1fb5e5ac176a03eb9c4fee933f467c231647daa18ea779fcb5ceaede"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1dab03d63f2c6b8910a0eeda77fa78d40bc02929ab6650efe5294ec79ed8f07d"
  end

  depends_on "go" => :build
  depends_on "ttyd"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/koki-develop/clive/cmd.version=v#{version}")
  end

  test do
    system bin/"clive", "init"
    assert_path_exists testpath/"clive.yml"

    system bin/"clive", "validate"
    assert_match version.to_s, shell_output("#{bin}/clive --version")
  end
end
