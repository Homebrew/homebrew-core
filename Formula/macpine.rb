class Macpine < Formula
  desc "Lightweight Linux VMs on MacOS"
  homepage "https://beringresearch.github.io/macpine/"
  url "https://github.com/beringresearch/macpine/archive/refs/tags/v0.9.tar.gz"
  sha256 "fbbed218de0037d0fc82bc675fbe89b44202f757f12a5ab53f32ff70345ee1c2"
  license "Apache-2.0"
  head "https://github.com/beringresearch/macpine.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?\.?(\d+(?:\.\d+)*)$/i)
    strategy :git do |tags, regex|
      tags.map do |tag|
        version = tag[regex, 1]
        next if version.blank?

        # Naively convert tags like `v.01` to `0.1`
        tag.match?(/^v\.?\d+$/i) ? version.chars.join(".") : version
      end
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4e1da6b8f34a22fc5fc63ba08b7bfac98e49810dc48480eb02d482e58027faff"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "31fdc359d83fed29fe4dd9d31c0a2e47c847d24769fedee8830b2387ee095422"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "86804d74a4c347c33f10d281e0194d4847a74c5b9995ceaa3f3eec8e4305b0c7"
    sha256 cellar: :any_skip_relocation, ventura:        "d6436309f60f3f0b4280a4fd4d1d78ab7cda32377815958d868f0e09cd750717"
    sha256 cellar: :any_skip_relocation, monterey:       "b73b6106d67192cbcaaefdd79dc4e7600e0898ca02ab500be56acf525880b14c"
    sha256 cellar: :any_skip_relocation, big_sur:        "cdd5fd51572c843ac660d140a6c48f229e90b531cb1ad169e448781d6b2a0d78"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f18fb694cde179cafbffe3b48f2bcee4f89b2604aa44ce43557b757433403987"
  end

  depends_on "go" => :build
  depends_on "qemu"

  conflicts_with "alpine", because: "both install `alpine` binaries"

  def install
    system "make", "install", "PREFIX=#{prefix}"
    generate_completions_from_executable(bin/"alpine", "completion")
  end

  test do
    assert_match "NAME OS STATUS SSH PORTS ARCH PID", shell_output("#{bin}/alpine list")
  end
end
