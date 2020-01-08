class Needle < Formula
  desc "Compile-time safe Swift dependency injection framework with real code"
  homepage "https://github.com/uber/needle"
  url "https://github.com/uber/needle.git",
      :tag      => "v0.11.0",
      :revision => "c7bdc2b94877e70d30fa8c05505672074f297144"

  bottle do
    cellar :any_skip_relocation
    sha256 "d7b4102e80a103f7578d5220d89691350de90341ba9fa06980026d874d295393" => :catalina
    sha256 "f3d9fb6053eeb5d55f434a12e891a81e9eea06bfc51715dbba3276c03ebfb448" => :mojave
    sha256 "b3a85d1dc8c443a13ef9f901c2f77a80ed88105d6db2a5aacbe236c9741d5f22" => :high_sierra
  end

  depends_on :xcode => ["10.0", :build]
  depends_on :xcode => "6.0"

  def install
    system "make", "install", "BINARY_FOLDER_PREFIX=#{prefix}"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/needle version")
  end
end
