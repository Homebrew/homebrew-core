class Nixpacks < Formula
  desc "App source + Nix packages + Docker = Image"
  homepage "https://nixpacks.com/"
  url "https://github.com/railwayapp/nixpacks/archive/refs/tags/v1.16.0.tar.gz"
  sha256 "768d4b8d0b7ec3cee4addde7332c6d92fee2898679816c5921d8cf6a01443242"
  license "MIT"
  head "https://github.com/railwayapp/nixpacks.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fa724265432d4cefffc60bf882ce80ccc6e1d5c1fe88952abff2ba43fcc61c8b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1ec1c75498c784e31a7c47a70329f4d128a6d046f940840082772533b41c6b8a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "53175c255ae4d0773cebdbf5c97dacf9115b2f5d8feb33b6a149a931eeeae9e3"
    sha256 cellar: :any_skip_relocation, ventura:        "a1ab0a17e348a4b666ac9bd6fc421d582cb7d801d7638eaeec2a5ccdef12e5db"
    sha256 cellar: :any_skip_relocation, monterey:       "854e317759f2aed885a475bfbae43dbc0cf25109e40b7846e11a759874038196"
    sha256 cellar: :any_skip_relocation, big_sur:        "f91c037d89b20da5b14d9f706da73ea34bfd9a9a28caba435823d4b26645080a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "349b63ae6785c4fdeec9d4f7c49ee880d24936231061c5fb7868b4e432dad685"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/nixpacks build #{testpath} --name test", 1)
    assert_match "Nixpacks was unable to generate a build plan for this app", output

    assert_equal "nixpacks #{version}", shell_output("#{bin}/nixpacks -V").chomp
  end
end
