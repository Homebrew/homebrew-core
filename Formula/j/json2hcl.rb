class Json2hcl < Formula
  desc "Convert JSON to HCL, and vice versa"
  homepage "https://github.com/kvz/json2hcl"
  url "https://github.com/kvz/json2hcl/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "ac10155d2d86a196a97e9cfb98e7a66f0b0505dee8904bbd3e32979370b81f34"
  license "MIT"
  head "https://github.com/kvz/json2hcl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e9c88c5eaf2de4b9f1be6b75a686717fcee660d091d3bfdfe28b42c459ae63b4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3a798a235db04843eee5ce55e66bc4bd3b1c197b9868fe945fba5137be4f190e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3a798a235db04843eee5ce55e66bc4bd3b1c197b9868fe945fba5137be4f190e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3a798a235db04843eee5ce55e66bc4bd3b1c197b9868fe945fba5137be4f190e"
    sha256 cellar: :any_skip_relocation, sonoma:        "62798fba3369e97896eb088773cef0d613b1ce3caa6b952b19f780038a8dad65"
    sha256 cellar: :any_skip_relocation, ventura:       "62798fba3369e97896eb088773cef0d613b1ce3caa6b952b19f780038a8dad65"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "303143d4460ea51e1170665de7e9fe7a7ceca23b2db82b0a8679ebd32d95772a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2948c8a75a038d66472436983a09b1e32cab8b7dc9a5d3d3b8dfec86a75a2eaa"
  end

  deprecate! date: "2025-10-26", because: :repo_archived

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/json2hcl -version")

    (testpath/"input.json").write <<~JSON
      {
        "hello": "world"
      }
    JSON

    assert_equal "\"hello\" = \"world\"", shell_output("#{bin}/json2hcl < input.json")

    (testpath/"input.tf").write <<~HCL
      hello = "world"
    HCL

    assert_equal "{\n  \"hello\": \"world\"\n}", shell_output("#{bin}/json2hcl -reverse < input.tf").chomp
  end
end
