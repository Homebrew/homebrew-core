class Afsctool < Formula
  desc "Utility for manipulating HFS+ compressed files"
  homepage "https://brkirch.wordpress.com/afsctool/"
  url "https://docs.google.com/uc?export=download&id=0BwQlnXqL939ZQjBQNEhRQUo0aUk"
  version "1.6.4"
  sha256 "bb6a84370526af6ec1cee2c1a7199134806e691d1093f4aef060df080cd3866d"
  license "GPL-3.0"
  revision 2

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "01af9a80d59e870a48adcbf1eb0cba0a3dd0a4013df397114c4c0f21f16e3916"
    sha256 cellar: :any_skip_relocation, big_sur:       "e7d401a4f723f58ad588e5b2fb5b19c6d76e7faed0385d0b3eef59d1f933e1ee"
    sha256 cellar: :any_skip_relocation, catalina:      "f418e15be4bafdcb1a85e14c3148c8d4af1b300bd6ed3e4a30eca3725459ac48"
    sha256 cellar: :any_skip_relocation, mojave:        "15c264a828ed98a42cc5ac68869c16b8306f73effe108e50bb1f731574311c51"
    sha256 cellar: :any_skip_relocation, high_sierra:   "72e92414d524b82ec1d8381ad50f55bd330f1109a5e10bca4235300fee557caf"
    sha256 cellar: :any_skip_relocation, sierra:        "96437b04a2974c215979550d3d70b4c8e3f609e76954ca41059c6f246da452ee"
  end

  depends_on :macos

  # Fixes Sierra "Unable to compress" issue; reported upstream on 24 July 2017
  patch :p2 do
    url "https://github.com/vfx01j/afsctool/commit/26293a3809c9ad1db5f9bff9dffaefb8e201a089.patch?full_index=1"
    sha256 "69ec72b2d6f89b53e93c7bacef1916ea4cf815e4b3e7ab4ee8010c31de1d4e66"
  end

  # Fixes High Sierra "Expecting f_type of 17 or 23. f_type is 24" issue
  # Acknowledged by upstream 12 Apr 2018:
  # https://github.com/Homebrew/homebrew-core/pull/20898#issuecomment-380727547
  patch :p2, :DATA

  def install
    system ENV.cc, ENV.cflags, "-lz", "afsctool.c",
                   "-framework", "CoreServices", "-o", "afsctool"
    bin.install "afsctool"
  end

  test do
    path = testpath/"foo"
    path.write "some text here."
    system "#{bin}/afsctool", "-c", path
    system "#{bin}/afsctool", "-v", path
  end
end

__END__
diff --git a/afsctool_34/afsctool.c b/afsctool_34/afsctool.c
index 8713407fa673f216e69dfc36152c39bc1dea4fe7..7038859f43e035be44c9b8cfbb1bb76a93e26e0a 100644
--- a/afsctool_34/afsctool.c
+++ b/afsctool_34/afsctool.c
@@ -104,8 +104,8 @@ void compressFile(const char *inFile, struct stat *inFileInfo, long long int max

	if (statfs(inFile, &fsInfo) < 0)
		return;
-	if (fsInfo.f_type != 17 && fsInfo.f_type != 23) {
-		printf("Expecting f_type of 17 or 23. f_type is %i.\n", fsInfo.f_type);
+	if (fsInfo.f_type != 17 && fsInfo.f_type != 23 && fsInfo.f_type != 24) {
+		printf("Expecting f_type of 17, 23 or 24. f_type is %i.\n", fsInfo.f_type);
		return;
	}
	if (!S_ISREG(inFileInfo->st_mode))
