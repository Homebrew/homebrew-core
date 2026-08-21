class Precious < Formula
  desc "One code quality tool to rule them all"
  homepage "https://github.com/houseabsolute/precious"
  url "https://github.com/houseabsolute/precious/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "87b5c72e22f83ac502721da58d5560866a8efccefc6f55646d59ce7402d74d0a"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/houseabsolute/precious.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f24818ceecfd4c4e8e12bcaa4e19a02e658b498490c692e1c71d3815b4248c11"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "39264124b7ea655e5cb82d7749b64f4db75b40129af08c91ba24c61c8095a7df"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a23e351493fa1958e8ef75626c8d2688cbc195dfb6dfaff7d45e44625307866d"
    sha256 cellar: :any_skip_relocation, sonoma:        "11356601ddd944a8d5194a9a196834557dab4eaf52280232b7f896b3bc959b50"
    sha256 cellar: :any,                 arm64_linux:   "c41cf9907998c5f514d4986715d280441cc87e434082ab8610074d1048354d51"
    sha256 cellar: :any,                 x86_64_linux:  "3ffd97b986131e784ac20084f7386d6cd1b6184cc771e19f50fd60b8007df21f"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/precious --version")

    system bin/"precious", "config", "init", "--auto"
    assert_path_exists testpath/"precious.toml"
  end
end
