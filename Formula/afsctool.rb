class Afsctool < Formula
  desc "Utility for manipulating HFS+ compressed files"
  homepage "https://brkirch.wordpress.com/afsctool/"
  url "https://bintray.com/homebrew/mirror/afsctool-1.6.4.zip"
  mirror "https://docs.google.com/uc?export=download&id=0BwQlnXqL939ZQjBQNEhRQUo0aUk"
  version "1.6.4"
  sha256 "bb6a84370526af6ec1cee2c1a7199134806e691d1093f4aef060df080cd3866d"
  revision 2

  bottle do
    cellar :any_skip_relocation
    sha256 "dae94371d947e9ddf0da4efd50425652753944da5f96c6aaa835b5ad1c361596" => :high_sierra
    sha256 "ad17b0f173670e0e7909de0086dbfc8e3db2fef0a6a576875d199d6c14b8f212" => :sierra
    sha256 "28e53f9426f88d7aaa41ef956a41aec8a68f5363d9e570a6be70e61e583e6b8f" => :el_capitan
  end

  # Fixes Sierra "Unable to compress" issue; reported upstream on 24 July 2017
  patch do
    url "https://github.com/vfx01j/afsctool/commit/26293a3809c9ad1db5f9bff9dffaefb8e201a089.diff?full_index=1"
    sha256 "a541526679eb5d2471b3f257dab6103300d950f7b2f9d49bbfeb9f27dfc48542"
  end

  # Fixes High Sierra "Expecting f_type of 17 or 23. f_type is 24" issue
  # Acknowledged by upstream 12 Apr 2018:
  # https://github.com/Homebrew/homebrew-core/pull/20898#issuecomment-380727547
  patch :DATA

  def install
    cd "afsctool_34" do
      system ENV.cc, ENV.cflags, "-lz", "afsctool.c",
                     "-framework", "CoreServices", "-o", "afsctool"
      bin.install "afsctool"
    end
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
