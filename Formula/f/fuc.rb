class Fuc < Formula
  desc "Modern, performance focused unix commands"
  homepage "https://github.com/supercilex/fuc"
  url "https://github.com/supercilex/fuc/archive/refs/tags/3.0.1.tar.gz"
  sha256 "13a964e49ce2298cc30a592e0364388905281ed3b546030de598d6a69aad7935"
  license "Apache-2.0"
  head "https://github.com/supercilex/fuc.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7e6b612e78c41e121889d1fca0c92dd5da7c60b3ea79cbe0eebebb0c24ef60f6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b807f9bf0c43cd24274b3f01ff77effd5cb49299358468187cab4aa2dd6b6d42"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ba60785ceb2ffff3cf7c98e866e8f92a06a326806feba585480b9bf949406a3c"
    sha256 cellar: :any_skip_relocation, sonoma:        "8d47b1787da96027b648a26aa2294766bb57534f53d055ad2f58e5791cc57b6c"
    sha256 cellar: :any_skip_relocation, ventura:       "0acf25893189799daee85b04cb93cd4d3a0e8979ffed2ade3b8d3589a721b35a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "176df6c08209d57df9420ebc47c55f76ca43bd6ce8e16bdfc675dd84b7b9d40f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "45c14c83d99d7057a36cf2b03ddba70424c63ed6590a56ed0fbcfc603c0374d1"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cpz")
    system "cargo", "install", *std_cargo_args(path: "rmz")
  end

  test do
    system bin/"cpz", test_fixtures("test.png"), testpath/"test.png"
    system bin/"rmz", testpath/"test.png"

    assert_match "cpz #{version}", shell_output("#{bin}/cpz --version")
    assert_match "rmz #{version}", shell_output("#{bin}/rmz --version")
  end
end
