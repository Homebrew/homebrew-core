class Caqtdm < Formula
  desc "Channel Access Qt Display Manager"
  homepage "https://github.com/caqtdm/caqtdm"
  url "https://github.com/caqtdm/caqtdm/archive/refs/tags/V4.5.0.tar.gz"
  sha256 "153a3d7355a6f6412343b0e2cb876a3dafee06c97e3f1fdcb849320134ee6d1e"
  license "GPL-3.0-only"
  head "https://github.com/caqtdm/caqtdm.git", branch: "Development"

  depends_on "qtbase" => :build
  depends_on "epicsbase"
  depends_on "python"
  depends_on "qt"
  depends_on "qt5compat"
  depends_on "qtimageformats"
  depends_on "qtnetworkauth"
  depends_on "qtpositioning"
  depends_on "qtserialbus"
  depends_on "qwt"
  depends_on "zeromq"

  def install
    require "macho"

    ENV["QTDIR"] = Formula["qt"].opt_prefix
    ENV.append_path "PATH", Formula["qt"].opt_bin
    ENV["EPICS_BASE"] = Formula["epicsbase"].opt_prefix
    ENV["EPICS_HOST_ARCH"] = "darwin-aarch64"
    ENV["EPICSINCLUDE"] = Formula["epicsbase"].opt_prefix
    ENV["EPICSINCLUDE"] += "/include"
    ENV["EPICSLIB"] = Formula["epicsbase"].opt_prefix
    ENV["EPICSLIB"] += "/lib/#{ENV["EPICS_HOST_ARCH"]}"
    ENV["CAQTDM_MODBUS"] = "1"

    ENV["CAQTDM_GPS"] = "1"
    ENV["PRODUCT_BUNDLE_IDENTIFIER"] = "ch.psi.caqtdm"
    ENV["QTDIR"] = Formula["qt"].opt_prefix
    ENV["QTHOME"] = Formula["qt"].opt_prefix
    ENV["QWTHOME"] = Formula["qwt"].opt_prefix
    ENV["CAQTDM_COLLECT"] = prefix.to_s
    ENV["QTCONTROLS_LIBS"] = prefix.to_s
    ENV["QWTVERSION"] = "6.1"
    ENV["QWTLIBNAME"] = "qwt"
    ENV["QWTLIB"] = Formula["qwt"].opt_prefix
    ENV["QWTLIB"] += "/lib"
    ENV["QWTINCLUDE"] = Formula["qwt"].opt_prefix
    ENV["QWTINCLUDE"] += "/lib/qwt.framework/Headers"

    ENV["PYTHONVERSION"] = Formula["python"].version.major.to_s
    ENV["PYTHONVERSION"] += "."
    ENV["PYTHONVERSION"] += Formula["python"].version.minor.to_s
    ENV["PYTHONLIB"] = Formula["python"].opt_prefix
    ENV["PYTHONLIB"] += "/Frameworks/Python.framework/Versions/"
    ENV["PYTHONLIB"] += ENV["PYTHONVERSION"].to_s
    ENV["PYTHONLIB"] += "/lib/"
    ENV["PYTHONINCLUDE"] = Formula["python"].opt_prefix
    ENV["PYTHONINCLUDE"] += "/Frameworks/Python.framework/Versions/"
    ENV["PYTHONINCLUDE"] += ENV["PYTHONVERSION"].to_s
    ENV["PYTHONINCLUDE"] += "/include/python"
    ENV["PYTHONINCLUDE"] += ENV["PYTHONVERSION"].to_s

    puts ">> Detected QWTLIB: #{ENV["QWTLIB"]}"
    puts ">> Detected QWTINCLUDE: #{ENV["QWTINCLUDE"]}"
    puts ">> Detected qwt: #{Formula["qwt"].opt_prefix}"

    puts ">> Detected PYTHONVERSION: #{ENV["PYTHONVERSION"]} "
    puts ">> Detected PYTHONLIB: #{ENV["PYTHONLIB"]} "
    puts ">> Detected PYTHONINCLUDE: #{ENV["PYTHONINCLUDE"]} "

    ENV["SDKROOT"] = MacOS.sdk_for_formula(self).path

    os = OS.mac? ? "macx" : OS.kernel_name.downcase
    compiler = ENV.compiler.to_s.match?("clang") ? "clang" : "g++"

    # system "qmake", "PREFIX=#{prefix} release -spec #{os}-#{compiler}"
    system Formula["qtbase"].bin/"qmake", "all.pro", "PREFIX=#{prefix} release -spec #{os}-#{compiler}"
    system "make"
    system "make", "install"
    if OS.mac?
      app_bin = "#{prefix}/caQtDM.app/Contents/MacOS/caQtDM"

      frameworks = "#{prefix}/caQtDM.app/Contents/Frameworks"
      plugins =  "#{prefix}/caQtDM.app/Contents/PlugIns/controlsystems"
      design = "#{prefix}/caQtDM.app/Contents/PlugIns/designer"
      lib_qtcontrols = "#{frameworks}/libqtcontrols.dylib"

      plugin_epics3 = "#{plugins}/libepics3_plugin.dylib"
      plugin_epics4 = "#{plugins}/libepics4_plugin.dylib"
      plugin_sf = "#{plugins}/libarchiveSF_plugin.dylib"
      plugin_http = "#{plugins}/libarchiveHTTP_plugin.dylib"
      plugin_demo = "#{plugins}/libdemo_plugin.dylib"
      plugin_env = "#{plugins}/libenvironment_plugin.dylib"
      plugin_gps =  "#{plugins}/libgps_plugin.dylib"
      plugin_modbus = "#{plugins}/libmodbus_plugin.dylib"

      MachO::Tools.change_install_name(app_bin, "libcaQtDM_Lib.dylib", "@rpath/libcaQtDM_Lib.dylib", strict: false)
      MachO::Tools.change_install_name(app_bin, "libqtcontrols.dylib", "@rpath/libqtcontrols.dylib", strict: false)

      MachO::Tools.change_install_name(plugin_epics3,
                                       "libcaQtDM_Lib.dylib", "@rpath/libcaQtDM_Lib.dylib", strict: false)
      MachO::Tools.change_install_name(plugin_epics4,
                                       "libcaQtDM_Lib.dylib", "@rpath/libcaQtDM_Lib.dylib", strict: false)
      MachO::Tools.change_install_name(plugin_sf,
                                       "libqtcontrols.dylib", "@rpath/libqtcontrols.dylib", strict: false)
      MachO::Tools.change_install_name(plugin_sf,
                                       "libcaQtDM_Lib.dylib", "@rpath/libcaQtDM_Lib.dylib", strict: false)

      MachO::Tools.change_install_name(plugin_http,
                                       "libqtcontrols.dylib", "@rpath/libqtcontrols.dylib", strict: false)
      MachO::Tools.change_install_name(plugin_http,
                                       "libcaQtDM_Lib.dylib", "@rpath/libcaQtDM_Lib.dylib", strict: false)

      MachO::Tools.change_install_name(plugin_demo,
                                       "libcaQtDM_Lib.dylib", "@rpath/libcaQtDM_Lib.dylib", strict: false)
      MachO::Tools.change_install_name(plugin_modbus,
                                       "libqtcontrols.dylib", "@rpath/libqtcontrols.dylib", strict: false)
      MachO::Tools.change_install_name(plugin_modbus,
                                       "libcaQtDM_Lib.dylib", "@rpath/libcaQtDM_Lib.dylib", strict: false)

      MachO::Tools.change_install_name(plugin_env,
                                 "libqtcontrols.dylib", "@rpath/libqtcontrols.dylib", strict: false)
      MachO::Tools.change_install_name(plugin_env,
                                 "libcaQtDM_Lib.dylib", "@rpath/libcaQtDM_Lib.dylib", strict: false)

      MachO::Tools.change_install_name(plugin_gps,
                                 "libcaQtDM_Lib.dylib", "@rpath/libcaQtDM_Lib.dylib", strict: false)

      MachO::Tools.change_install_name(lib_qtcontrols,
                                       "libadlParser.dylib", "#{frameworks}/libadlParser.dylib", strict: false)
      MachO::Tools.change_install_name(lib_qtcontrols,
                                       "libedlParser.dylib", "#{frameworks}/libedlParser.dylib", strict: false)

      MachO::Tools.change_install_name("#{design}/libqtcontrols_controllers_plugin.dylib",
                                       "libqtcontrols.dylib", "@rpath/libqtcontrols.dylib", strict: false)
      MachO::Tools.change_install_name("#{design}/libqtcontrols_graphics_plugin.dylib",
                                       "libqtcontrols.dylib", "@rpath/libqtcontrols.dylib", strict: false)
      MachO::Tools.change_install_name("#{design}/libqtcontrols_monitors_plugin.dylib",
                                       "libqtcontrols.dylib", "@rpath/libqtcontrols.dylib", strict: false)
      MachO::Tools.change_install_name("#{design}/libqtcontrols_utilities_plugin.dylib",
                                       "libqtcontrols.dylib", "@rpath/libqtcontrols.dylib", strict: false)

      write_default="defaults write #{prefix}/caQtDM.app/Contents/Info"
      system ("#{write_default} LSEnvironment -dict QT_PLUGIN_PATH #{prefix}/caQtDM.app/Contents/PlugIns")
      system ("#{write_default} CFBundleIdentifier -string ch.psi.caQtDM")

      system ("echo '#!/bin/sh' > #{prefix}/caQtDM.app/Contents/Resources/caqtdm")

      caqtdm_resource = "#{prefix}/caQtDM.app/Contents/Resources/caqtdm"
      stdout_caqtdm = "-n --stdout $(tty) --stderr $(tty) #{prefix}/caQtDM.app --args "
      system ("echo 'open #{stdout_caqtdm} \"$@\"' >> #{caqtdm_resource}")
      system ("echo ' ' >> #{caqtdm_resource}")
      system ("chmod 755 #{caqtdm_resource}")

      designer_path = "#{prefix}/caQtDM.app/Contents/Resources/caqtdm_designer"
      system ("echo '#!/bin/bash' > #{designer_path}")
      commanddata = "'export DYLD_LIBRARY_PATH=#{prefix}/caQtDM.app/Contents/Frameworks '"
      system ("echo #{commanddata} >> #{designer_path}")
      system ("echo 'export QT_PLUGIN_PATH=#{prefix}/caQtDM.app/Contents/PlugIns ' >> #{designer_path}")

      calldesigner = "#{Formula["qttools"].libexec}/Designer.app/Contents/MacOS/Designer"
      system ("echo 'exec \"#{calldesigner}\" \"$@\"' >> #{designer_path}")
      system ("echo ' ' >> #{prefix}/caQtDM.app/Contents/Resources/caqtdm_designer")
      system ("chmod 755 #{prefix}/caQtDM.app/Contents/Resources/caqtdm_designer")

      system "codesign", "--force", "--sign", "-", "-vvv", "--deep", app_bin

      lib.install_symlink prefix/"caQtDM.app/Contents/libqtcontrols.dylib"=> "libqtcontrols.dylib"
      lib.install_symlink prefix/"caQtDM.app/Contents/libcaQtDM_Lib.dylib"=> "libcaQtDM_Lib.dylib"

      bin.install_symlink prefix/"caQtDM.app/Contents/Resources/caqtdm" => "caqtdm"
      bin.install_symlink prefix/"caQtDM.app/Contents/Resources/caqtdm_designer" => "caqtdm_designer"
      bin.install_symlink prefix/"adl2ui.app/Contents/MacOS/adl2ui" => "adl2ui"
      bin.install_symlink prefix/"edl2ui.app/Contents/MacOS/edl2ui" => "edl2ui"
    end
  end

  test do
    # Optional: Ein einfacher Test, ob das Binary da ist
    assert_path_exists bin/"caqtdm", :exist?
    assert_path_exists prefix/"caQtDM.app", :exist?
    output = Utils.safe_popen_read("caqtdm", "-help", err: :out)  rescue ""
    assert_match "Usage:", output



  end
end
