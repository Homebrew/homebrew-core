class Carthage < Formula
  desc "Decentralized dependency manager for Cocoa"
  homepage "https://github.com/Carthage/Carthage"
  url "https://github.com/Carthage/Carthage.git",
      :tag      => "0.33.0",
      :revision => "c8ac06e106b6b61f907918bfb2b7a5c432de4678",
      :shallow  => false
  head "https://github.com/Carthage/Carthage.git", :shallow => false

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "2d1dfd8accb374b3e14b71feb6ff531ff19936832e41581852a763ec84b7c278" => :catalina
    sha256 "7183b69c0a12b7c4126751f4c6d5483717ae495aa0aa67fb9825fe6c00357013" => :mojave
  end

  depends_on :xcode => ["10.0", :build]

  # Upstream fix for Xcode 11 swift compiler bug
  # https://github.com/Carthage/Carthage/issues/2831
  # https://bugs.swift.org/browse/SR-11423
  patch :DATA

  def install
    if MacOS::Xcode.version >= "10.2" && MacOS.full_version < "10.14.4" && MacOS.version >= "10.14"
      odie "Xcode >=10.2 requires macOS >=10.14.4 to build Swift formulae."
    end

    system "make", "prefix_install", "PREFIX=#{prefix}"
    bash_completion.install "Source/Scripts/carthage-bash-completion" => "carthage"
    zsh_completion.install "Source/Scripts/carthage-zsh-completion" => "_carthage"
    fish_completion.install "Source/Scripts/carthage-fish-completion" => "carthage.fish"
  end

  test do
    (testpath/"Cartfile").write 'github "jspahrsummers/xcconfigs"'
    system bin/"carthage", "update"
  end
end
__END__
diff -pur a/Source/carthage/Update.swift b/Source/carthage/Update.swift
--- a/Source/carthage/Update.swift	2019-10-19 10:59:50.000000000 +0200
+++ b/Source/carthage/Update.swift	2019-10-19 11:03:15.000000000 +0200
@@ -65,12 +65,13 @@ public struct UpdateCommand: CommandProt
			let buildDescription = "skip the building of dependencies after updating\n(ignored if --no-checkout option is present)"

			let dependenciesUsage = "the dependency names to update, checkout and build"
+			let defaultLogPath: String? = nil

			return curry(self.init)
				<*> mode <| Option(key: "checkout", defaultValue: true, usage: "skip the checking out of dependencies after updating")
				<*> mode <| Option(key: "build", defaultValue: true, usage: buildDescription)
				<*> mode <| Option(key: "verbose", defaultValue: false, usage: "print xcodebuild output inline (ignored if --no-build option is present)")
-				<*> mode <| Option(key: "log-path", defaultValue: nil, usage: "path to the xcode build output. A temporary file is used by default")
+				<*> mode <| Option(key: "log-path", defaultValue: defaultLogPath, usage: "path to the xcode build output. A temporary file is used by default")
				<*> mode <| Option(key: "new-resolver", defaultValue: false, usage: "use the new resolver codeline when calculating dependencies. Default is false")
				<*> BuildOptions.evaluate(mode, addendum: "\n(ignored if --no-build option is present)")
				<*> CheckoutCommand.Options.evaluate(mode, dependenciesUsage: dependenciesUsage)
