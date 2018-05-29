class PuppetBolt < Formula
  desc "Utility to execute commands, scripts, and tasks on remote systems"
  homepage "https://github.com/puppetlabs/bolt"
  version "0.20.3"

  if MacOS.version == :el_capitan
    @image_name = "puppet-bolt-#{version}-1.osx10.11"
    url "http://downloads.puppetlabs.com/mac/10.11/PC1/x86_64/#{@image_name}.dmg"
    sha256 "d4cbc0a9c824cfa05dd540f7eaa5c036484bd651613a60ec7a929a22fb099441"
  elsif MacOS.version == :sierra
    @image_name = "puppet-bolt-#{version}-1.osx10.12"
    url "http://downloads.puppetlabs.com/mac/10.12/PC1/x86_64/#{@image_name}.dmg"
    sha256 "ca2407e8b258705d998b6d3143dcfb6d208a5453b02b09ab945ce5b21dd93d00"
  elsif MacOS.version == :high_sierra
    @image_name = "puppet-bolt-#{version}-1.osx10.13"
    url "http://downloads.puppetlabs.com/mac/10.13/PC1/x86_64/#{@image_name}.dmg"
    sha256 "d623713f352a318fcdbc105a03c87faa055190819b171f1604e5e147579be21a"
  end

  def install
    system "hdiutil", "attach", "#{@image_name}.dmg"
    # `installer` requires root, but this command doesn't succeed for me locally.
    # I'm not sure what to do?
    system "sudo", "installer", "-package", "/Volumes/#{@image_name}/puppet-bolt-#{version}-1-installer.pkg", "-target", "/"
    system "hdiutil", "detach", "/Volumes/#{@image_name}"
  end

  test do
    assert_match version.to_s, shell_output("bolt --version")
  end
end